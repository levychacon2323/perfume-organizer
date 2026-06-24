import Constants from 'expo-constants';

export const env = {
  appVersion: (Constants.expoConfig?.version ?? '0.0.0') as string,
  isDev: __DEV__,
} as const;
