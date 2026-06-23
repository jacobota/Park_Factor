import React, { useState } from 'react';
import { LayoutChangeEvent, StyleProp, StyleSheet, TouchableOpacity, View, ViewStyle } from 'react-native';
import Svg, { Defs, LinearGradient, RadialGradient, Rect, Stop } from 'react-native-svg';
import { colors, radius } from '@/theme';

/**
 * The app's signature card surface. Layers three effects over the elevated base:
 *  - a vertical depth sheen (light top edge → transparent),
 *  - an accent glow washing across the whole card from the top-right,
 *  - an accent left bar + brighter top "sheen" border.
 * The gradient layer is drawn at the card's measured pixel size (not "100%"), so it always
 * covers edge-to-edge. Visual props are forced last so a passed `style` only adds layout.
 */
export function Card({
  children,
  style,
  accent = colors.primary,
  glow = true,
  onPress,
}: {
  children: React.ReactNode;
  style?: StyleProp<ViewStyle>;
  accent?: string;
  glow?: boolean;
  onPress?: () => void;
}) {
  const [size, setSize] = useState({ w: 0, h: 0 });
  const onLayout = (e: LayoutChangeEvent) => {
    const { width, height } = e.nativeEvent.layout;
    setSize((s) => (s.w === width && s.h === height ? s : { w: width, h: height }));
  };

  const Wrap: React.ComponentType<any> = onPress ? TouchableOpacity : View;
  return (
    <Wrap
      style={[style, styles.card, { borderLeftColor: accent }]}
      onPress={onPress}
      onLayout={onLayout}
      activeOpacity={onPress ? 0.85 : undefined}
    >
      {size.w > 0 && (
        <Svg width={size.w} height={size.h} style={styles.layer} pointerEvents="none">
          <Defs>
            <LinearGradient id="cardDepth" x1="0" y1="0" x2="0" y2="1">
              <Stop offset="0" stopColor="#FFFFFF" stopOpacity="0.05" />
              <Stop offset="1" stopColor="#FFFFFF" stopOpacity="0" />
            </LinearGradient>
            <RadialGradient
              id="cardGlow"
              cx={size.w * 0.8}
              cy={size.h * -0.1}
              rx={size.w * 0.95}
              ry={size.h * 1.15}
              gradientUnits="userSpaceOnUse"
            >
              <Stop offset="0" stopColor={accent} stopOpacity={glow ? '0.12' : '0'} />
              <Stop offset="1" stopColor={accent} stopOpacity="0" />
            </RadialGradient>
          </Defs>
          <Rect x="0" y="0" width={size.w} height={size.h} fill="url(#cardDepth)" />
          <Rect x="0" y="0" width={size.w} height={size.h} fill="url(#cardGlow)" />
        </Svg>
      )}
      {children}
    </Wrap>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: colors.elevated,
    borderRadius: radius.lg,
    borderWidth: StyleSheet.hairlineWidth,
    borderColor: colors.border,
    borderTopColor: '#43464D', // brighter top edge = subtle sheen
    borderLeftWidth: 3,
    overflow: 'hidden',
  },
  layer: { position: 'absolute', top: 0, left: 0 },
});
