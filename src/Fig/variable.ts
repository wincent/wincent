export default function variable(name: string, fallback?: string): string {
  // TODO: actual implementation
  // lookup order:
  // top level platform/profile variable
  // local aspect.json defaults
  // inline fallback parameter?
  return fallback || name;
}
