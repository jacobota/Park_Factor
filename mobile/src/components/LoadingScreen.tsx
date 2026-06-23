import React, { useEffect, useRef } from 'react';
import { Animated, Image, StyleSheet, View, useWindowDimensions } from 'react-native';
import { colors } from '@/theme';

/**
 * LoadingScreenView — full-screen logo with a gentle repeating pulse.
 * (SwiftUI used a bouncy repeatForever scale 1.0 -> 1.15 after a 1s delay.)
 */
export function LoadingScreen() {
  const scale = useRef(new Animated.Value(1)).current;
  const { width } = useWindowDimensions();

  useEffect(() => {
    const timer = setTimeout(() => {
      Animated.loop(
        Animated.sequence([
          Animated.spring(scale, { toValue: 1.15, useNativeDriver: true, friction: 4 }),
          Animated.spring(scale, { toValue: 1.0, useNativeDriver: true, friction: 4 }),
        ]),
      ).start();
    }, 1000);
    return () => clearTimeout(timer);
  }, [scale]);

  const size = width * 0.85;

  return (
    <View style={styles.container}>
      <Animated.Image
        source={require('@/assets/ParkFactorLogo.jpg')}
        style={[{ width: size, height: size, transform: [{ scale }] }, styles.logo]}
        resizeMode="contain"
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.secondary, alignItems: 'center', justifyContent: 'center' },
  logo: { borderRadius: 12 },
});
