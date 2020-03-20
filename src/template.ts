/**
 * @see https://en.wikipedia.org/wiki/Jinja_(template_engine)
 * @see https://jinja.palletsprojects.com/
 */
export default function template(input: string) {
  // {% %} statement
  // {{ }} expression
  // {# #} comment
  // # ## line statements
  return input.toUpperCase();
}
