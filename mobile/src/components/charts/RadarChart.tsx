import React from 'react';
import { StyleSheet, View } from 'react-native';
import Svg, { Circle, Line, Polygon, Text as SvgText } from 'react-native-svg';
import { colors } from '@/theme';

export interface RadarAxis {
  label: string;
  max: number;
}

/**
 * Radar/spider chart (SpiderGraphView) drawn with react-native-svg: spokes, concentric grid
 * rings, an outer polygon, and the filled data polygon. Values map to radius via value/max.
 */
export function RadarChart({
  axes,
  values,
  color,
  size = 300,
  rings = 3,
}: {
  axes: RadarAxis[];
  values: number[];
  color: string;
  size?: number;
  rings?: number;
}) {
  const n = axes.length;
  const center = size / 2;
  const radius = center - 44; // leave room for labels

  // Axis 0 points east, going clockwise — matches the Swift layout.
  const angleFor = (i: number) => (2 * Math.PI * i) / n;
  const pointAt = (r: number, i: number): [number, number] => [
    center + r * Math.cos(angleFor(i)),
    center + r * Math.sin(angleFor(i)),
  ];
  const polygon = (r: (i: number) => number) =>
    axes.map((_, i) => pointAt(r(i), i).join(',')).join(' ');

  const dataPolygon = axes
    .map((axis, i) => pointAt(radius * Math.min(1, (values[i] ?? 0) / axis.max), i).join(','))
    .join(' ');

  return (
    <View style={styles.wrapper}>
      <Svg width={size} height={size}>
        {/* grid rings */}
        {Array.from({ length: rings }, (_, k) => (
          <Polygon
            key={`ring-${k}`}
            points={polygon(() => (radius * (k + 1)) / (rings + 1))}
            stroke={colors.white}
            strokeOpacity={0.4}
            strokeWidth={1.5}
            fill="none"
          />
        ))}
        {/* spokes */}
        {axes.map((_, i) => {
          const [x, y] = pointAt(radius, i);
          return <Line key={`spoke-${i}`} x1={center} y1={center} x2={x} y2={y} stroke={colors.white} strokeWidth={1.5} />;
        })}
        {/* outer border */}
        <Polygon points={polygon(() => radius)} stroke={colors.white} strokeWidth={2} fill="none" />
        {/* data */}
        <Polygon points={dataPolygon} stroke={color} strokeWidth={3} fill={color} fillOpacity={0.6} />
        {axes.map((axis, i) => {
          const [vx, vy] = pointAt(radius * Math.min(1, (values[i] ?? 0) / axis.max), i);
          return <Circle key={`dot-${i}`} cx={vx} cy={vy} r={3} fill={color} />;
        })}
        {/* labels */}
        {axes.map((axis, i) => {
          const [lx, ly] = pointAt(radius + 16, i);
          return (
            <SvgText
              key={`label-${i}`}
              x={lx}
              y={ly}
              fill={colors.white}
              fontSize={12}
              textAnchor="middle"
              alignmentBaseline="middle"
            >
              {axis.label}
            </SvgText>
          );
        })}
      </Svg>
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: { alignItems: 'center', justifyContent: 'center' },
});
