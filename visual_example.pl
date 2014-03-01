#!env perl

use v5.12;
use strict;
use warnings;
use queue_as_stack;

my $q = queue_as_stack->new(show_visual=>1);

say "empty stacks";
$q->show_stacks;

for my $value (1..5)
{
    say "enqueue a value: $value";
    $q->enqueue($value);
}
say "dequeue a value";
$q->dequeue;

say "dequeue a second value";
$q->dequeue;

say "enqueue two more values, they will sit in in_stack";
$q->enqueue(11,12);

say "dequeue a third value, only pops out_stack";
$q->dequeue;

say "dequeue a 4th value, only pops out_stack";
$q->dequeue;

say "dequeue a 5th value, pops final out_stack value";
$q->dequeue;

say "next dequeue will move in_stack to out_stack";
$q->dequeue;

say "final dequeue";
$q->dequeue;
