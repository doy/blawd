package Blawd::Renderer::RSS;
use Moose;
use 5.10.0;
use namespace::autoclean;
use XML::RSS;
use MooseX::Aliases;
with qw(Blawd::Renderer::API);

has rss => (
    isa        => 'XML::RSS',
    is         => 'ro',
    lazy_build => 1,
);

has extension => ( isa => 'Str', is => 'ro', default => '.xml' );

sub _build_rss { XML::RSS->new( version => '1.0' ) }

alias 'render_as_fragment' => 'render';

sub render {
    my ( $self, $index ) = @_;
    $self->rss->channel(
        title => $index->title,
        link  => $index->link,
    );
    while ( my $entry = $index->next ) {
        $self->rss->add_item(
            title       => $entry->title,
            link        => $entry->link,
            description => $entry->render_as_fragment,
            dc          => {
                date   => $entry->date . 'Z',
                author => $entry->author,
            }
        );
    }
    return $self->rss->as_string;
}

__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 NAME

Blawd::Renderer::RSS - A class to render Blawd::Indexes as RSS

=head1 SYNOPSIS

use Blawd::Renderer::RSS;

=head1 DESCRIPTION

The Blawd::Renderer::RSS class implements a renderer for RSS.

=head1 METHODS

=head2 render_as_fragment (Blawd::Index $index)

Render an Index as RSS

=head2 render (Blawd::Index $index)

Render an Index as RSS

=head1 PRIVATE METHODS

=head2 _build_rss

=head1 AUTHOR

Chris Prather (chris@prather.org)

=head1 LICENCE

Copyright 2009 by Chris Prather.

This software is free.  It is licensed under the same terms as Perl itself.

=cut
