/*
 * Copyright 2012-2019 CodeLibs Project and the Others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
package org.codelibs.fess.job;

import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.codelibs.fess.util.ComponentUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class ExecJob {

    private static final Logger logger = LoggerFactory.getLogger(ExecJob.class);

    protected JobExecutor jobExecutor;

    protected String sessionId;

    protected boolean useLocalElasticsearch = true;

    protected String logFilePath;

    protected String logLevel;

    protected List<String> jvmOptions = new ArrayList<>();

    protected String lastaEnv;

    public abstract String execute();

    protected abstract String getExecuteType();

    public ExecJob jobExecutor(final JobExecutor jobExecutor) {
        this.jobExecutor = jobExecutor;
        return this;
    }

    public ExecJob sessionId(final String sessionId) {
        this.sessionId = sessionId;
        return this;
    }

    public ExecJob logFilePath(final String logFilePath) {
        this.logFilePath = logFilePath;
        return this;
    }

    public ExecJob logLevel(final String logLevel) {
        this.logLevel = logLevel;
        return this;
    }

    public ExecJob useLocalElasticsearch(final boolean useLocalElasticsearch) {
        this.useLocalElasticsearch = useLocalElasticsearch;
        return this;
    }

    public ExecJob remoteDebug() {
        return jvmOptions("-Xdebug", "-Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=localhost:8000");
    }

    public ExecJob gcLogging() {
        final StringBuilder buf = new StringBuilder(100);
        buf.append("-Xlog:gc*,gc+age=trace,safepoint:file=");
        if (logFilePath != null) {
            buf.append(logFilePath);
        } else {
            buf.append(ComponentUtil.getSystemHelper().getLogFilePath());
        }
        buf.append(File.separator);
        buf.append("gc-").append(getExecuteType()).append(".log");
        buf.append(":utctime,pid,tags:filecount=32,filesize=64m");
        return jvmOptions(buf.toString());
    }

    public ExecJob jvmOptions(final String... options) {
        for (final String s : options) {
            this.jvmOptions.add(s);
        }
        return this;
    }

    public ExecJob lastaEnv(final String env) {
        this.lastaEnv = env;
        return this;
    }

    protected void addSystemProperty(final List<String> cmdList, final String name, final String defaultValue, final String appendValue) {
        final String value = System.getProperty(name);
        if (value != null) {
            final StringBuilder buf = new StringBuilder();
            buf.append("-D").append(name).append("=").append(value);
            if (appendValue != null) {
                buf.append(appendValue);
            }
            cmdList.add(buf.toString());
        } else if (defaultValue != null) {
            cmdList.add("-D" + name + "=" + defaultValue);
        }
    }

    protected void deleteTempDir(final File ownTmpDir) {
        if (ownTmpDir == null) {
            return;
        }
        if (!FileUtils.deleteQuietly(ownTmpDir)) {
            logger.warn("Could not delete a temp dir: " + ownTmpDir.getAbsolutePath());
        }
    }

    protected void appendJarFile(final String cpSeparator, final StringBuilder buf, final File libDir, final String basePath) {
        final File[] jarFiles = libDir.listFiles((FilenameFilter) (dir, name) -> name.toLowerCase().endsWith(".jar"));
        if (jarFiles != null) {
            for (final File file : jarFiles) {
                buf.append(cpSeparator);
                buf.append(basePath);
                buf.append(file.getName());
            }
        }
    }

}