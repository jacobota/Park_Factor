/**
 * Design tokens — direct translation of Extensions.swift (Color + Font).
 *
 * Swift used a single mint primary, true-black secondary, and a dark page bg,
 * plus Norwester (display) and Archivo Narrow (data) font families at fixed sizes.
 */

export const colors = {
  // Color.parkFactorPrimary = Color(red: 0, green: 0.996, blue: 0.773)
  primary: '#00FEC5',
  // Color.parkFactorSecondary = .black
  secondary: '#000000',
  // Color.parkFactorAppPageBackground = Color(red: 0.117, green: 0.115, blue: 0.115)
  pageBackground: '#1E1D1D',

  white: '#FFFFFF',
  lightGray: '#AEAEB2', // iOS systemGray-ish, used for unselected tab tint
  gray: '#8E8E93',
  cardBackground: '#2C2B2B',
  border: '#3A3A3C',

  // Continuous percentile gradient anchors (red -> yellow -> green)
  bad: '#E0245E',
  mid: '#F5C518',
  good: '#2ED47A',
} as const;

/** Font families registered in App.tsx via expo-font. */
export const fonts = {
  norwester: 'Norwester',
  archivo: 'ArchivoNarrow',
} as const;

/**
 * Named text styles mirroring the Font.parkFactor* statics in Extensions.swift.
 * Use as: <Text style={typography.title}>.
 */
export const typography = {
  // Norwester
  title: { fontFamily: fonts.norwester, fontSize: 32 },
  subtitleNorwester: { fontFamily: fonts.norwester, fontSize: 26 },
  usernameNorwester: { fontFamily: fonts.norwester, fontSize: 24 },
  bigTextNorwester: { fontFamily: fonts.norwester, fontSize: 22 },
  textNorwester: { fontFamily: fonts.norwester, fontSize: 18 },
  smallTextNorwester: { fontFamily: fonts.norwester, fontSize: 16 },

  // Archivo Narrow
  username: { fontFamily: fonts.archivo, fontSize: 24 },
  subtitleArchivo: { fontFamily: fonts.archivo, fontSize: 26 },
  bigTextArchivo: { fontFamily: fonts.archivo, fontSize: 24 },
  text: { fontFamily: fonts.archivo, fontSize: 22 },
  smallText: { fontFamily: fonts.archivo, fontSize: 18 },
  subSectionText: { fontFamily: fonts.archivo, fontSize: 15 },
} as const;

export const spacing = { xs: 4, sm: 8, md: 12, lg: 16, xl: 24 } as const;
export const radius = { sm: 8, md: 12, lg: 16 } as const;
