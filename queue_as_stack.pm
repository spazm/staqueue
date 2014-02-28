package queue_as_stack;

use List::Util qw(min);

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

requires O(m) space for storing the two queues.  2m of temporary space is required for the two stacks.

=cut

use Moo;
use namespace::clean;

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

=item _build__out_stack_min

Lazy builder to calculate the minimum value in the output stack.

The queue maintains the smallest value on insert.  When a minimum value is dequeued, the object must calculate the current smallest value.

=cut

sub _build__out_stack_min
{
    my $self = shift;

    return min(@{$self->out_stack});
}

sub _build__in_stack_min
{
    return undef;
}

=item getMinimum()

returns the value of the smallest numeric value in the queue.  Only appropriate when storing numeric values.

returns undef if there are no values in the queue.

=cut

sub getMinimum
{
    my $self = shift;
    my $in = $self->_in_stack_min;
    my $out = $self->_out_stack_min;
    if (defined $in and defined $out)
    {
        return min($in, $out);
    }
    elsif( defined $in )
    {
        return $in;
    }
    else
    {
        return $out;
    }
}

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

            while ( @{ $self->in_stack } )
            {

                # copy in_stack minimum to out_stack here
                push( @{ $self->out_stack }, pop @{ $self->in_stack } );
            }
        }

        return undef if !@{ $self->out_stack };

        my $return = pop @{ $self->out_stack };

        if ( $self->_has_out_stack_min && $return <= $self->_out_stack_min )
        {
            print STDERR "popping [$return] and clearing out_stack_min\n";
            $self->_clear_out_stack_min;
        }

        return $return;
}

=back

=cut

1;
