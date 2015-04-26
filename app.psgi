#!/usr/bin/env perl

use strict;
use warnings;
use Dancer2;
use Try::Tiny;
use Net::Address::IP::Local;

get '/' => sub { return "This are not the droids you are looking for..." };

for my $v (qw( 20150425 latest )) {
  get "/$v/host/address" => sub {
    content_type 'text/plain';

    my $res;
    try { $res = Net::Address::IP::Local->public_ipv4 }
    catch {
      $res = "$_";
      status 503;
    };

    return $res;
  };
}

dance;
