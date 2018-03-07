use Concurrent::Trie;
use Test;

given Concurrent::Trie.new -> $ct {
    nok $ct.contains('x'), 'Empty Trie does not contain x';
    nok $ct.contains('foo'), 'Empty Trie does not contain foo';
    is-deeply $ct.entries.list, (), 'No entries in empty Trie';
    is-deeply $ct.entries('').list, (), '...even with empty prefix';
    is-deeply $ct.entries('x').list, (), '...and especially with non-empty prefix';

    lives-ok { $ct.insert('a') }, 'Can insert one-char string to trie';
    ok $ct.contains('a'), 'Now contains that one-char string';
    nok $ct.contains('b'), 'Does not contain a different one-char string';
    nok $ct.contains('ab'),
        'Does not contain a two-char string with prefix of the one we added';
    is-deeply $ct.entries.list, ('a',), 'Correct entries result';
    is-deeply $ct.entries('a'), ('a',), 'Correct entries result with prefix match';
    is-deeply $ct.entries('aa'), (), 'No entries for prefix non-match (1)';
    is-deeply $ct.entries('b'), (), 'No entries for prefix non-match (2)';

    lives-ok { $ct.insert('abc') }, 'Can make second insertion';
    ok $ct.contains('a'), 'Still contains original entry';
    ok $ct.contains('abc'), 'Also contains second entry';
    nok $ct.contains('ab'), 'Does not falsely report partial entry';
    nok $ct.contains('b'), 'Does not contain something not added';
    is-deeply $ct.entries.sort.list, ('a', 'abc'), 'Correct 2 entries in result';
    is-deeply $ct.entries('a').sort.list, ('a', 'abc'),
        'Correct 2 entries that have shared prefix';
    is-deeply $ct.entries('ab').list, ('abc',),
        'Do not result result shorter than the prefix';
    is-deeply $ct.entries('b'), (), 'No entries for prefix non-match';

    lives-ok { $ct.insert('wxyz') }, 'Can make third entry';
    is-deeply $ct.entries.sort.list, ('a', 'abc', 'wxyz'), 'Have all 3 entries';

    nok $ct.contains('wx'), 'Does not falsely report partial entry';
    nok $ct.contains('wxyzz'), 'Does not falsely report entry with prefix';
    lives-ok { $ct.insert('wx') }, 'Can insert something with an existing prefix';
    ok $ct.contains('wx'), 'That prefix is now reported as being contained';
    is-deeply $ct.entries.sort.list, ('a', 'abc', 'wx', 'wxyz'),
        'Have all 4 entries in entries list';

    lives-ok { $ct.insert('wxyz') }, 'Adding entry already in there works';
    is-deeply $ct.entries.sort.list, ('a', 'abc', 'wx', 'wxyz'),
        'No duplication in entries list';
}

done-testing;
