#! /bin/sh

export REPO_TOKEN=RltkmM2Z4YjS0yAjabbeiuWHOy4b6sv32

# Install dart_coveralls; gather and send coverage data.
if [ "$REPO_TOKEN" ]; then
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --token $REPO_TOKEN \
    --retry 2 \
    --exclude-test-files \
    test/dart_tags_test.dart
fi