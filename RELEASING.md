# Releasing

A release is two things: the libraries (`okay-agent`, `okay-agent-cli`; JVM and Scala Native) as a Maven repository on
GitHub Pages — the `gh-pages` branch, under `maven/`, served at https://okay-effects.github.io/okay-agent/maven — and
the native command for macOS on Apple Silicon, an asset of the GitHub release, which `install.sh` downloads.

1. On `master`, everything green: `sbt test` (JVM and Native).
2. The version in `build.sbt`, `ThisBuild / version`, without `-SNAPSHOT`, committed, tagged (`v0.1.0`).
3. The libraries:

   ```sh
   rm -rf target/pages-maven && sbt publish
   git worktree add /tmp/okay-agent-pages gh-pages     # the first time: git worktree add --orphan -b gh-pages …
   mkdir -p /tmp/okay-agent-pages/maven && rsync -a target/pages-maven/ /tmp/okay-agent-pages/maven/
   touch /tmp/okay-agent-pages/.nojekyll
   git -C /tmp/okay-agent-pages add -A && git -C /tmp/okay-agent-pages commit -m "release 0.1.0"
   git -C /tmp/okay-agent-pages push origin gh-pages
   ```

4. The command: `sbt cliNative/nativeLink`, then `bin/okay-agent` in a tarball, the release's asset:

   ```sh
   mkdir -p /tmp/oa/bin && cp cli/.native/target/scala-3.3.8/okay-agent-cli /tmp/oa/bin/okay-agent
   tar czf okay-agent-macos-arm64.tar.gz -C /tmp/oa bin
   gh release create v0.1.0 okay-agent-macos-arm64.tar.gz --title "okay-agent 0.1.0" --notes-file …
   ```

While nobody depends on a release, it is republished under the same version (the tag moved, the asset replaced with
`gh release upload --clobber`) rather than a new one made for each change.
