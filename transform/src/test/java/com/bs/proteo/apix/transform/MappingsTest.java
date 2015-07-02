package com.bs.proteo.apix.transform;

import static org.junit.Assert.*;

/**
 * Created by jgilniet on 01/07/2015.
 */
public class MappingsTest {

    @org.junit.Test
    public void testGetTargetNamespace() throws Exception {
        assertEquals(
                Mappings.getTargetNamespace("http://proteo.bs.com/soa/service/mainframe/Validacioncv/domain/message"),
                "http://proteo.bs.com/firms/validacioncv/business/validacioncv/domain/message/");
    }

    @org.junit.Test
    public void testGetSourceNamespace() throws Exception {
        assertEquals(
                Mappings.getSourceNamespace("http://proteo.bs.com/firms/validacioncv/business/validacioncv/domain/message/"),
                "http://proteo.bs.com/soa/service/mainframe/Validacioncv/domain/message");
    }

    @org.junit.Test
    public void testGetRoutingKey() throws Exception {
        assertEquals(
                Mappings.getRoutingKey("http://proteo.bs.com/soa/service/mainframe/Validacioncv/domain/message"),
                "Validacioncv");
    }
}