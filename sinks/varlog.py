#!/usr/bin/env python
'''Supports flushing metrics to a file, meant to be in /var/log like any other log.  This is primarily meant for testing and initial deployment.'''
import sys

DEFAULT_PREFIX = 'statsite.'

def transform_metrics(metrics, prefix=DEFAULT_PREFIX):
    return ['{prefix}{key} {value} {timestamp}\n'.format(prefix=prefix,
                                                       key=key,
                                                       value=value,
                                                       timestamp=timestamp)
            for key, value, timestamp in (metric.split('|')
                                          for metric in metrics)]

def main():
    if 1 < len(sys.argv):
        prefix = 2 < len(sys.argv) and sys.argv[2] or DEFAULT_PREFIX
        try:
            with open(sys.argv[1], 'a') as f:
                f.writelines(transform_metrics(sys.stdin.read().splitlines()))
                              
        except IOError, e:
            print >>sys.stderr, 'Error: Append:', e
            sys.exit(2)
    else:
        print >>sys.stderr, 'Syntax:', sys.argv[0], 'output-filename-and-path [prefix="{}"]'.format(DEFAULT_PREFIX)
        sys.exit(1)

if '__main__' == __name__:
    main()
    
