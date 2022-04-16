String parseMonth(String month) {
  switch (month.toLowerCase()) {
    case 'janeiro':
      return '01';
    case 'fevereiro':
      return '02';
    case 'março':
      return '03';
    case 'abril':
      return '04';
    case 'maio':
      return '05';
    case 'junho':
      return '06';
    case 'julho':
      return '07';
    case 'agosto':
      return '08';
    case 'setembro':
      return '09';
    case 'outubro':
      return '10';
    case 'novembro':
      return '11';
    case 'dezembro':
      return '12';
  }
  return '';
}
