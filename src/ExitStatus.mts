/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

export default class ExitStatus extends Error {
  status: number;

  constructor(status: number) {
    super();
    this.status = status;
  }
}
