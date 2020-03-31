#!/bin/bash

echo $@ | ssh s4ros.it "nc localhost 8666"
