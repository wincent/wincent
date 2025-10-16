# Yarn

## Initial vendoring

```
cd vendor
wget https://yarnpkg.com/latest.tar.gz
gunzip latest.tar.gz
tar xf latest.tar
rm latest.tar
ln -s yarn-v1.22.19 yarn
git add -A .
```

## Updated vendored version

```
cd vendor
rm -r yarn-${OLD_VERSION}
wget https://yarnpkg.com/latest.tar.gz
gunzip latest.tar.gz
tar xf latest.tar
rm latest.tar
ln -sf yarn-v${NEW_VERSION} yarn
git add -A .
```
