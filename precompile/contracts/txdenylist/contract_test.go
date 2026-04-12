// Copyright (C) 2019-2025, Ava Labs, Inc. All rights reserved.
// See the file LICENSE for licensing terms.

package txdenylist

import (
	"testing"

	"github.com/ava-labs/subnet-evm/precompile/allowlist/allowlisttest"
)

func TestTxDenyListRun(t *testing.T) {
	allowlisttest.RunPrecompileWithAllowListTests(t, Module, nil)
}
