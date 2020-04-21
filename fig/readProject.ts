import {log} from './console.js';
import {promises as fs} from './fs.js';
import {Project, assertProject} from './types/Project.js';

export default async function readProject(path: string): Promise<Project> {
    log.debug(`Reading project configuration: ${path}`);

    const json = await fs.readFile(path, 'utf8');

    const project = JSON.parse(json);

    try {
        assertProject(project);
    } catch (error) {
        throw new Error(`${error.message} in ${path}`);
    }

    return project;
}
