#!/usr/bin/env tsx
/**
 * Should called by tar.sh, build-images.sh, cd-distribute-images.sh
 * Run under the top folder
 * @return PkgInfoForBuild
 */
import assert from 'node:assert'

import { $ } from 'zx'
import minimist from 'minimist'


$.verbose = true
await $`pwd && date`

const argv = minimist(process.argv.slice(2))

const verbose = !! argv.verbose
verbose && console.info(argv)

const pkg: string | undefined = argv.p
assert(typeof pkg === 'string', 'param -p <pkgDir> required, like: -p ./packages/svc/ ')
