package com.bs.proteo.tools;

import java.util.HashMap;

/**
 * Created by jordi on 2/07/15.
 */
public class MultiMap <K1, K2, V> {

    private final HashMap<K1, CompoundValue<K1, K2, V>> map1 = new HashMap<K1, CompoundValue<K1, K2, V>>();
    private final HashMap<K2, CompoundValue<K1, K2, V>> map2 = new HashMap<K2, CompoundValue<K1, K2, V>>();

    public MultiMap() {
    }

    public void put(final K1 key1, final K2 key2, final V value) {
        final CompoundValue<K1, K2, V> compoundValue = new CompoundValue<K1, K2, V>(key1, key2, value);
        map1.put(key1, compoundValue);
        map2.put(key2, compoundValue);
    }

    public V getValueByKey1(final K1 key) {
        return map1.get(key).value;
    }

    public V getValueByKey2(final K2 key) {
        return map2.get(key).value;
    }

    public K2 getKey2ByKey1(final K1 key) {
        return map1.get(key).key2;
    }

    public K1 getKey1ByKey2(final K1 key) {
        return map2.get(key).key1;
    }

    public V removeByKey1(final K1 key1) {
        final CompoundValue<K1, K2, V> oldCompoundValue = map1.remove(key1);
        map2.remove(oldCompoundValue.key2);

        return oldCompoundValue.value;
    }

    public V removeByKey2(final K2 key2) {
        final CompoundValue<K1, K2, V> oldCompoundValue = map2.remove(key2);
        map1.remove(oldCompoundValue.key1);

        return oldCompoundValue.value;
    }

    private static class CompoundValue<K1, K2, V> {
        private final K1 key1;
        private final K2 key2;
        private final V value;

        public CompoundValue(final K1 key1, final K2 key2,
                             final V value) {
            this.key1 = key1;
            this.key2 = key2;
            this.value = value;
        }
    }
}
