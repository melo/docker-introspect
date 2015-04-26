#!/usr/bin/env perl

use strict;
use warnings;
use Dancer2;

get '/' => sub { return "This are not the droids you are looking for..." };

dance;
