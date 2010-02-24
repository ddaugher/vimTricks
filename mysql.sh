#!/bin/bash
mysql test<<EOFMYSQL
SELECT * from commands;
EOFMYSQL
