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
}

done-testing;
