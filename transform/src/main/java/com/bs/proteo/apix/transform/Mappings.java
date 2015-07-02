package com.bs.proteo.apix.transform;

import org.apache.commons.collections.map.MultiKeyMap;

public class Mappings {

    private static MultiKeyMap mappings = null;

    protected static synchronized void loadMappings() {
        MultiKeyMap workingMap = new MultiKeyMap();

        workingMap.put("http://proteo.bs.com/soa/service/mainframe/Validacioncv/domain/message", "http://proteo.bs.com/firms/validacioncv/business/validacioncv/domain/message/", "Validacioncv");

        mappings = workingMap;
    }

    protected static MultiKeyMap getMappings() {
        if (mappings == null) loadMappings();
        return mappings;
    }

    public static String getTargetNamespace(String sourceNamespace) {
        String targetNamespace;

        targetNamespace = (String) getMappings().get(sourceNamespace);

        if (sourceNamespace.equals("http://proteo.bs.com/soa/service/mainframe/Validacioncv/domain/message"))
            targetNamespace = "http://proteo.bs.com/firms/validacioncv/business/validacioncv/domain/message/";
        else
            throw new RuntimeException("Source namespace unknown.");

        System.out.println(sourceNamespace + " >> " + targetNamespace);
        return targetNamespace;
    }

    public static String getSourceNamespace(String targetNamespace) {
        String sourceNamespace;
        if (targetNamespace.equals("http://proteo.bs.com/firms/validacioncv/business/validacioncv/domain/message/"))
            sourceNamespace = "http://proteo.bs.com/soa/service/mainframe/Validacioncv/domain/message";
        else
            throw new RuntimeException("Target namespace unknown.");

        System.out.println(targetNamespace + " >> " + sourceNamespace);
        return sourceNamespace;
    }

    public static String getRoutingKey(String sourceNamespace) {
        String routingKey;
        if (sourceNamespace.equals("http://proteo.bs.com/soa/service/mainframe/Validacioncv/domain/message"))
            routingKey = "Validacioncv";
        else
            throw new RuntimeException("Source namespace unknown.");

        System.out.println(sourceNamespace + " >> " + routingKey);
        return routingKey;
    }
}