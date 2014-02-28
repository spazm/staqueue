package queue_as_stack;

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

sub push
{
    my $self = shift;
    push @{ $self->in_stack }, $_[0];
}

sub pop
{
    my $self = shift;
    if ( !@{ $self->out_stack } )
    {

        # copy all items from in_stack to out_stack
        while ( @{ $self->in_stack } )
        {
            CORE::push( @{ $self->out_stack }, pop @{ $self->in_stack } );
        }
    }
    return pop @{ $self->out_stack };
}

1;
