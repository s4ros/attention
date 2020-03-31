#!/bin/bash

echo $@ | nc -N localhost 8666
