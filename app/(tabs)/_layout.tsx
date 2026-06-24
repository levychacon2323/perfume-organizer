import { SymbolView } from 'expo-symbols';
import { Tabs } from 'expo-router';

export default function TabLayout() {
  return (
    <Tabs
      screenOptions={{
        tabBarActiveTintColor: '#1A1A1A',
        headerShown: false,
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: 'Coleção',
          tabBarIcon: ({ color }) => (
            <SymbolView name="house" tintColor={color} size={24} />
          ),
        }}
      />
      <Tabs.Screen
        name="catalogo"
        options={{
          title: 'Catálogo',
          tabBarIcon: ({ color }) => (
            <SymbolView name="magnifyingglass" tintColor={color} size={24} />
          ),
        }}
      />
      <Tabs.Screen
        name="wishlist"
        options={{
          title: 'Wishlist',
          tabBarIcon: ({ color }) => (
            <SymbolView name="heart" tintColor={color} size={24} />
          ),
        }}
      />
    </Tabs>
  );
}
