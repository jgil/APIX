package com.bs.proteo.tools;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by jordi on 2/07/15.
 */
public class MultiMapTest {

    private MultiMap<String, String, String> mmap;

    @Before
    public void SetUp() {
        mmap = new MultiMap<String, String, String>();
    }

    @Test
    public void test() throws Exception {
        mmap.put("key1", "key2", "value");
        assertEquals(mmap.getValueByKey1("key1"), "value");
        assertEquals(mmap.getValueByKey2("key2"), "value");
        assertEquals(mmap.getKey2ByKey1("key1"), "key2");
        assertEquals(mmap.getKey1ByKey2("key2"), "key1");
    }
}