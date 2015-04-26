#!/usr/bin/env perl

package Introspect;
use Web::Simple;

sub dispatch_request {
  return (
    sub (GET) { [200, ['Content-type', 'text/plain'], ['This are not the droids you are looking for']] },
    sub ()    { [405, ['Content-type', 'text/plain'], ['Method not allowed']] },
  );
}

Introspect->run_if_script;
