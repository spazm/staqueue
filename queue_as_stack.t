use Test::More;

use_ok('queue_as_stack');

my $q = queue_as_stack->new();
is( $q->pop(), undef, 'undef when poping an empty queue' );

$q->push(1);
is( $q->pop(), 1, 'push and pop a single value' );

$q->push($_) for ( 1, 2, 3, 4 );

#check internals
is_deeply( $q->in_stack, [ 1, 2, 3, 4 ], 'all items pushed to in_stack' );
is( $q->pop, 1, 'first item popped from queue' );
is_deeply(
    $q->out_stack,
    [ 4, 3, 2 ],
    'all items pushed into out_stack in reverse order'
);
is( $q->pop, 2, 'second item popped from queue' );
is( $q->pop, 3, 'third item popped from queue' );
is( $q->pop, 4, 'fourth item popped from queue' );

done_testing;
