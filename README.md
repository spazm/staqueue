# NAME

queue\_as\_stack - an implementation of a queue using two stacks

# SYNOPSIS

    my $q = queue_as_stack->new();
    $q->enqueue(1);
    $q->enqueue(2);
    $q->dequeue;  # returns 1
    $q->dequeue;  # returns 2

# DESCRIPTION

Implements a queue (FIFO) by using two stacks (LIFO).

Items are pushed on to in\_stack as they are enqueued.
Items are popped off of out\_stack as they are dequeued.
If out\_stack is empty during a dequeue, all items are popped
from in\_stack and pushed onto out\_stack

requires O(m) space for storing the two queues.
O(2m) of temporary space is required for the two stacks if they don't dynamically resize.

# OPTIONS

- show\_visual

    flag to enable visualization.
    If non-zero, stack status will be shown during enqueue and dequeue operations.

- in\_stack

    an arrayref to override the in\_stack

- out\_stack

    an arrayref to override the out\_stack

# METHODS

- enqeue(value)

    push value(s) onto the queue.  Accepts an array and will push values into the queue from left-to-right

- dequeue()

    pop a single value from the queue

- getMinimum()

    returns the value of the smallest numeric value in the queue.  Only appropriate when storing numeric values.

    returns undef if there are no values in the queue.

- show\_stacks()

    Display the current state of the stacks.

# INTERNAL METHODS

- \_build\_\_out\_stack\_min

    Lazy builder to calculate the minimum value in the output stack.

    The queue maintains the smallest value on insert.  When a minimum value is dequeued, the object must calculate the current smallest value.

- \_build\_\_in\_stack\_min

    Lazy builder to calculate the minimum value in the input stack.

    This is a placeholder to return undef.
