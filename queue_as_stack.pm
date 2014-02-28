package queue_as_stack;

=pod

=head1 NAME

queue_as_stack - an implementation of a queue using two stacks

=head1 SYNOPSIS

    my $q = queue_as_stack->new();
    $q->push(1);
    $q->push(2);
    $q->pop;  # returns 1
    $q->pop;  # returns 2

=head1 DESCRIPTION

Implements a queue (FIFO) by using two stacks (LIFO).

Items are pushed on to in_stack as they are added to the queue.
Items are popped off of out_stack as they are removed from the queue.

If out_stack is empty, all items are popped from in_stack and pushed onto out_stack

=cut

use Moo;
use namespace::clean;

has in_stack => (
    is      => 'ro',
    default => sub { [] },
);

has out_stack => (
    is      => 'ro',
    default => sub { [] },
);

=head1 METHODS

=over 8

=item enqeue(value)

push value(s) onto the queue.  Accepts an array and will push values into the queue from left-to-right

=cut

sub enqueue
{
    my $self = shift;
    push @{ $self->in_stack }, $_ for @_;
}

=item dequeue()

pop a single value from the queue

=cut

sub dequeue
{
    my $self = shift;
    if ( !@{ $self->out_stack } )
    {

        # copy all items from in_stack to out_stack
        while ( @{ $self->in_stack } )
        {
            push( @{ $self->out_stack }, pop @{ $self->in_stack } );
        }
    }
    return pop @{ $self->out_stack };
}

=back

=cut

1;
