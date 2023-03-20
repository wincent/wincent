# Based on: https://github.com/actions/starter-workflows/blob/master/ci/node.js.yml

name: ci

on:
  push:
    branches: [main, next, pu]
  pull_request:
    branches: [main, next, pu]

jobs:

  check-lockfile:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.x]
    steps:
    - uses: actions/checkout@v2
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v1
      with:
        node-version: ${{ matrix.node-version }}
    - run: package.yam/A.P.I
    
