
const List<String> userTypes = [
  "Regular User",
  "Service Provider",
];


const List<String> profesions = [
  "Gardener",
  "Carpenter",
  "Smith",
  "Private Tutor",
  "Web Developper",
  "App Developper",
  "Full Stack Developper",
  "Driver",
  "Art",
  "Plumber",
  "Maid",
  "Electrician",
  "Ac units",
  "Pest Control",
  "Others"
];

String getZodicaSign({days,months}) {
  if (months == 1) {
    if (days >= 21) {
      return "Aquarius";
    } else {
      return "Capricorn";
    }
  } else if (months == 2) {
    if (days >= 20) {
      return "Picis";
    } else {
      return "Aquarius";
    }
  } else if (months == 3) {
    if (days >= 21) {
      return "Aries";
    } else {
      return "Pisces";
    }
  } else if (months == 4) {
    if (days >= 21) {
      return "Taurus";
    } else {
      return "Aries";
    }
  } else if (months == 5) {
    if (days >= 22) {
      return "Gemini";
    } else {
      return "Taurus";
    }
  } else if (months == 6) {
    if (days >= 22) {
      return "Cancer";
    } else {
      return "Gemini";
    }
  } else if (months == 7) {
    if (days >= 23) {
      return "Leo";
    } else {
      return "Cancer";
    }
  } else if (months == 8) {
    if (days >= 23) {
      return "Virgo";
    } else {
      return "Leo";
    }
  } else if (months == 9) {
    if (days >= 24) {
      return "Libra";
    } else {
      return "Virgo";
    }
  } else if (months == 10) {
    if (days >= 24) {
      return "Scorpio";
    } else {
      return "Libra";
    }
  } else if (months == 11) {
    if (days >= 23) {
      return "Sagittarius";
    } else {
      return "Scorpio";
    }
  } else if (months == 12) {
    if (days >= 22) {
      return "Capricorn";
    } else {
      return "Sagittarius";
    }
  }
  return "";
}
