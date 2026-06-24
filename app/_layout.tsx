import '../global.css';
import { Geist_300Light, Geist_400Regular, Geist_500Medium } from '@expo-google-fonts/geist';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useFonts } from 'expo-font';
import { Stack } from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { useEffect } from 'react';
import { View, Text } from 'react-native';
import 'react-native-reanimated';

import { useDatabaseMigrations } from '@/db/migrate';

export { ErrorBoundary } from 'expo-router';

export const unstable_settings = {
  initialRouteName: '(tabs)',
};

SplashScreen.preventAutoHideAsync();

const queryClient = new QueryClient();

export default function RootLayout() {
  const [fontsLoaded, fontError] = useFonts({
    Geist_300Light,
    Geist_400Regular,
    Geist_500Medium,
  });
  const { success: dbReady, error: dbError } = useDatabaseMigrations();

  useEffect(() => {
    if (fontError) throw fontError;
  }, [fontError]);

  useEffect(() => {
    if (fontsLoaded && dbReady) {
      SplashScreen.hideAsync();
    }
  }, [fontsLoaded, dbReady]);

  if (dbError) {
    return (
      <View className="flex-1 items-center justify-center bg-background p-4">
        <Text className="text-base text-destructive text-center">
          Erro ao iniciar banco de dados: {dbError.message}
        </Text>
      </View>
    );
  }

  if (!fontsLoaded || !dbReady) {
    return null;
  }

  return <RootLayoutNav />;
}

function RootLayoutNav() {
  return (
    <QueryClientProvider client={queryClient}>
      <Stack>
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen name="modal" options={{ presentation: 'modal' }} />
      </Stack>
    </QueryClientProvider>
  );
}
