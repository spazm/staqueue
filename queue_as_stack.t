use Test::More;

use_ok('queue_as_stack');

my $q = queue_as_stack->new();
is( $q->getMinimum, undef, 'undef getMinimum when empty' );
is( $q->dequeue(),  undef, 'undef when dequeue-ing an empty queue' );

$q->enqueue(1);
is( $q->getMinimum, 1, 'getMinimum for single entry' );
is( $q->dequeue(),  1, 'enqueue and dequeue a single value' );
is( $q->getMinimum, undef,
    'getMinimum undef after emptying a single item queue' );

$q->enqueue($_) for ( 1, 2, 3, 4 );
is( $q->getMinimum, 1, 'getMinimum for multiple entries in in_stack' );

#check internals
is_deeply( $q->in_stack, [ 1, 2, 3, 4 ], 'all items enqueued to in_stack' );
is( $q->dequeue, 1, 'first item dequeued from queue' );
is_deeply(
    $q->out_stack,
    [ 4, 3, 2 ],
    'all items enqueued into out_stack in reverse order'
);
is( $q->getMinimum, 2,     'getMinimum for 2' );
is( $q->dequeue,    2,     'second item dequeued from queue' );
is( $q->dequeue,    3,     'third item dequeued from queue' );
is( $q->getMinimum, 4,     'getMinimum for last entry' );
is( $q->dequeue,    4,     'fourth item dequeued from queue' );
is( $q->getMinimum, undef, 'getMinimum is undef for empty queue' );

done_testing;
