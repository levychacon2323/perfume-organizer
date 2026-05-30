import { Text, View } from 'react-native';

export default function HomeScreen() {
  return (
    <View className="flex-1 items-center justify-center bg-background">
      <Text className="text-3xl font-bold text-primary">
        Perfume Organizer
      </Text>
      <Text className="text-base text-muted-foreground mt-2">
        Setup funcionando
      </Text>
    </View>
  );
}