const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

export function fmtDate(d?: string): string {
  if (!d) return 'Present';
  const [year, month] = d.split('-');
  return `${MONTHS[parseInt(month) - 1]} ${year}`;
}
