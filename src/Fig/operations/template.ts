import * as fs from 'fs';

import {log} from '../../console';
import expand from '../../expand';
import Context from '../Context';

export default function template({
  // force,
  group,
  mode,
  owner,
  path,
  src,
  // sudo,
  variables,
}: {
  group?: string;
  path: string;
  mode?: string;
  owner?: string;
  src: string;
  variables?: Variables;
  // force?: boolean;
  // sudo?: boolean;
}) {
  log.info(`template ${src} -> ${path}`);
  // TODO expand paths
}
