#!/bin/bash

pub get || exit $

EXIT_CODE=0
dart format --fix --set-exit-if-changed . || EXIT_CODE=$?
dartanalyzer --fatal-infos --fatal-warnings . || EXIT_CODE=$?

exit $EXIT_CODE
