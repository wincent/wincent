# Updating

Compress PNGs with (eg):

```
pngcrush -ow -brute screenshot.png
```

Working within a Jujutsu workspace created with (eg):

```
jj workspace add -r a4b3e18b13c846acae3a210fd6f8d20cfd26130e media
```

Pushing to the remote requires setting up tracking:

```
jj bookmark track media --remote=origin
jj bookmark track media --remote=github
```
