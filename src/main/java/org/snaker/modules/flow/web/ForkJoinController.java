/* Copyright 2012-2013 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.snaker.modules.flow.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.snaker.engine.access.QueryFilter;
import org.snaker.engine.entity.Order;
import org.snaker.engine.entity.Process;
import org.snaker.engine.entity.Task;
import org.snaker.engine.model.WorkModel;
import org.snaker.framework.security.shiro.ShiroUtils;
import org.snaker.modules.base.service.SnakerEngineFacets;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * fork-join测试controller
 * @author yuqs
 * @since 0.1
 */
@Controller
@RequestMapping(value = "/flow/forkjoin")
public class ForkJoinController {
	@Autowired
	private SnakerEngineFacets facets;
	@RequestMapping(value = "all", method=RequestMethod.GET)
	public String all(Model model, String processId, String orderId, String taskId) {
		Process process = facets.getEngine().process().getProcessById(processId);
		List<WorkModel> models = process.getModel().getWorkModels();
		model.addAttribute("works", models);
		model.addAttribute("process", process);
		if(StringUtils.isNotEmpty(orderId) && StringUtils.isNotEmpty(taskId)) {
			Order order = facets.getEngine().query().getOrder(orderId);
			Task task = facets.getEngine().query().getTask(taskId);
			model.addAttribute("order", order);
			model.addAttribute("task", task);
		} else {
			Map<String, Object> args = new HashMap<String, Object>();
			args.put("task1.operator", ShiroUtils.getUsername());
			Order order = facets.startInstanceById(processId, ShiroUtils.getUsername(), args);
			List<Task> tasks = facets.getEngine().query().getActiveTasks(new QueryFilter().setOrderId(order.getId()));
			model.addAttribute("order", order);
			if(tasks != null && tasks.size() > 0) {
				model.addAttribute("task", tasks.get(0));
			}
		}
		return "flow/forkjoin/all";
	}
	
	@RequestMapping(value = "task1/save", method=RequestMethod.POST)
	public String task1Save(String orderId, String taskId) {
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("task2.operator", ShiroUtils.getUsername());
		args.put("task3.operator", ShiroUtils.getUsername());
		facets.execute(taskId, ShiroUtils.getUsername(), args);
		return "redirect:/snaker/task/active";
	}
	
	@RequestMapping(value = "task2/save", method=RequestMethod.POST)
	public String task2Save(String orderId, String taskId) {
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("task4.operator", ShiroUtils.getUsername());
		facets.execute(taskId, ShiroUtils.getUsername(), args);
		return "redirect:/snaker/task/active";
	}
	
	@RequestMapping(value = "task3/save", method=RequestMethod.POST)
	public String task3Save(String orderId, String taskId) {
		Map<String, Object> args = new HashMap<String, Object>();
		args.put("task4.operator", ShiroUtils.getUsername());
		facets.execute(taskId, ShiroUtils.getUsername(), args);
		return "redirect:/snaker/task/active";
	}
	
	@RequestMapping(value = "task4/save", method=RequestMethod.POST)
	public String task4Save(String orderId, String taskId, String taskName) {
		if(StringUtils.isEmpty(taskName)) {
			facets.execute(taskId, ShiroUtils.getUsername(), null);
		} else {
			Map<String, Object> args = new HashMap<String, Object>();
			args.put("task1.operator", ShiroUtils.getUsername());
			args.put("task2.operator", ShiroUtils.getUsername());
			args.put("task3.operator", ShiroUtils.getUsername());
			facets.executeAndJump(taskId, ShiroUtils.getUsername(), args, taskName);
		}
		return "redirect:/snaker/task/active";
	}
}
