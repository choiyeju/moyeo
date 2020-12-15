package org.moyeo.util.config;

import javax.sql.DataSource;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
@MapperScan({"org.moyeo.ctrl.mapper"})
public class MybatisConfig {

	private DataSource dataSource;
	
	@Value("#{dbcp['typeAliasesPackages']}")
	private String typeAliasesPackages;
	@Value("#{dbcp['driverClassName']}")
	private String driverClassName;
	@Value("#{dbcp['jdbcUrl']}")
	private String jdbcUrl;
	@Value("#{dbcp['username']}")
	private String username;
	@Value("#{dbcp['password']}")
	private String password;
	@Value("#{dbcp['maxPoolSize']}")
	private String maxPoolSize;
	
	@Bean(name = "txManager")
	public PlatformTransactionManager dataSourceTransactionManager() {
		return new DataSourceTransactionManager(dataSource());
	}

	@Bean
	public SqlSessionTemplate sqlSessionTemplate() throws Exception {
		SqlSessionTemplate sqlSessionTemplate = new SqlSessionTemplate(sqlSessionFactory());
		org.apache.ibatis.session.Configuration configuration = sqlSessionTemplate.getConfiguration();
		configuration.setMapUnderscoreToCamelCase(true);
		configuration.setCacheEnabled(false);
		return sqlSessionTemplate;
	}

	private SqlSessionFactory sqlSessionFactory() throws Exception {
		SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
		sessionFactory.setTypeAliasesPackage(typeAliasesPackages);
		sessionFactory.setDataSource(dataSource());
		
		return sessionFactory.getObject();
	}
	public DataSource dataSource(){
		if(dataSource==null){
			BasicDataSource basicDataSource = new BasicDataSource();
			basicDataSource.setDriverClassName(driverClassName);
			basicDataSource.setUrl(jdbcUrl);
			basicDataSource.setUsername(username);
			basicDataSource.setPassword(password);
			
			this.dataSource=basicDataSource;
		}
		return dataSource;
	}	
}
