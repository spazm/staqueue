package queue_as_stack;

use v5.12;
use List::Util qw(min);

=pod

=head1 NAME

queue_as_stack - an implementation of a queue using two stacks

=head1 SYNOPSIS

    my $q = queue_as_stack->new();
    $q->enqueue(1);
    $q->enqueue(2);
    $q->dequeue;  # returns 1
    $q->dequeue;  # returns 2

=head1 DESCRIPTION

Implements a queue (FIFO) by using two stacks (LIFO).

Items are pushed on to in_stack as they are enqueued.
Items are popped off of out_stack as they are dequeued.
If out_stack is empty during a dequeue, all items are popped
from in_stack and pushed onto out_stack

requires O(m) space for storing the two queues.
O(2m) of temporary space is required for the two stacks if they don't dynamically resize.

=cut

use Moo;
use namespace::clean;

=head1 OPTIONS

=over 8

=item show_visual

flag to enable visualization.
If non-zero, stack status will be shown during enqueue and dequeue operations.

=item in_stack

an arrayref to override the in_stack

=item out_stack

an arrayref to override the out_stack

=back

=cut

has show_visual => (
    is      => 'rw',
    default => 0,
);

has in_stack => (
    is      => 'ro',
    default => sub { [] },
);

has out_stack => (
    is        => 'ro',
    predicate => 1,
    default   => sub { [] },
);

has _in_stack_min => (
    is        => 'rwp',
    lazy      => 1,
    builder   => 1,
    predicate => 1,
    clearer   => 1,
);

has _out_stack_min => (
    is        => 'rwp',
    lazy      => 1,
    builder   => 1,
    predicate => 1,
    clearer   => 1,
);

=head1 METHODS

=over 8

=item enqeue(value)

push value(s) onto the queue.  Accepts an array and will push values into the queue from left-to-right

=cut

sub enqueue
{
    my $self = shift;
    for my $value (@_)
    {

        #maintain the min
        if ( !defined( $self->_in_stack_min )
            or $value < $self->_in_stack_min )
        {
            $self->_set__in_stack_min($value);
        }

        push @{ $self->in_stack }, $value;
        $self->show_stacks if $self->show_visual;
    }
}

=item dequeue()

pop a single value from the queue

=cut

sub dequeue
{
    my $self = shift;
    if ( !@{ $self->out_stack } )
    {

        # move items from in_stack to out_stack, can copy over min.
        $self->_set__out_stack_min( $self->_in_stack_min );
        $self->_clear_in_stack_min;

        $self->show_stacks if $self->show_visual;

        while ( @{ $self->in_stack } )
        {

            # copy in_stack minimum to out_stack here
            push( @{ $self->out_stack }, pop @{ $self->in_stack } );
            $self->show_stacks if $self->show_visual;
        }
    }

    return undef if !@{ $self->out_stack };

    my $return = pop @{ $self->out_stack };
    $self->show_stacks if $self->show_visual;

    if ( $self->_has_out_stack_min && $return <= $self->_out_stack_min )
    {
        $self->_clear_out_stack_min;
    }

    return $return;
}

=item getMinimum()

returns the value of the smallest numeric value in the queue.  Only appropriate when storing numeric values.

returns undef if there are no values in the queue.

=cut

sub getMinimum
{
    my $self = shift;
    my $in   = $self->_in_stack_min;
    my $out  = $self->_out_stack_min;
    if ( defined $in and defined $out )
    {
        return min( $in, $out );
    }
    elsif ( defined $in )
    {
        return $in;
    }
    else
    {
        return $out;
    }
}

=item show_stacks()

Display the current state of the stacks.

=cut

sub show_stacks
{
    my $self = shift;

    my @in  = @{ $self->in_stack };
    my @out = @{ $self->out_stack };
    say( "in:  ", join( ", ", @in ) );
    say( "out: ", join( ", ", @out ) );

    #    say ("queue: ", join(", ",@in,reverse(@out)));
    say '';
}

=back

=head1 INTERNAL METHODS

=over 8

=item _build__out_stack_min

Lazy builder to calculate the minimum value in the output stack.

The queue maintains the smallest value on insert.  When a minimum value is dequeued, the object must calculate the current smallest value.

=cut

sub _build__out_stack_min
{
    my $self = shift;

    return min( @{ $self->out_stack } );
}

=item _build__in_stack_min

Lazy builder to calculate the minimum value in the input stack.

This is a placeholder to return undef.

=cut

sub _build__in_stack_min
{
    return undef;
}

=back

=cut

1;
