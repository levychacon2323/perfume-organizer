import { Link, Stack } from 'expo-router';
import { Text, View } from 'react-native';

export default function NotFoundScreen() {
  return (
    <>
      <Stack.Screen options={{ title: 'Oops!' }} />
      <View className="flex-1 items-center justify-center p-5 bg-background">
        <Text className="text-xl text-foreground">Esta tela não existe.</Text>
        <Link href="/" className="mt-4 py-4">
          <Text className="text-sm text-primary">Ir para a tela inicial</Text>
        </Link>
      </View>
    </>
  );
}
