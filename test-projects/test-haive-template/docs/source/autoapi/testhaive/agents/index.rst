testhaive.agents
================

.. py:module:: testhaive.agents

TestHaive Agents - Agent implementations.

This package mimics the structure of haive.agents for testing documentation generation.



.. raw:: html
   
   <div class="autoapi-module-summary">
<span class="module-stat">2 classes</span>   </div>

.. autoapi-nested-parse::

   TestHaive Agents - Agent implementations.

   This package mimics the structure of haive.agents for testing documentation generation.




.. admonition:: Submodules (2)
   :class: note

   .. toctree::
      :maxdepth: 1
      :titlesonly:

      /autoapi/testhaive/agents/react/index
      /autoapi/testhaive/agents/simple/index

      
            
            

.. admonition:: Classes (2)
   :class: note

   .. autoapisummary::

      testhaive.agents.ReactAgent
      testhaive.agents.SimpleAgent

            
            

.. dropdown:: :octicon:`book` Complete API Documentation
   :open:
   :class-title: sd-font-weight-bold sd-text-info
   :class-container: sd-border-info

   .. grid:: 1 2 2 3
      :gutter: 2

      .. grid-item-card:: 
         :class-card: sd-border-0 sd-shadow-sm
         :class-title: sd-text-center sd-font-weight-bold

.. py:class:: ReactAgent(**kwargs)

            Bases: :py:obj:`testhaive.agents.simple.agent.SimpleAgent`


            ReactAgent implementing the ReAct (Reasoning and Acting) pattern.

            ReactAgent extends SimpleAgent with advanced reasoning capabilities, tool usage,
            and reflective thinking. It follows the ReAct pattern of reasoning about problems,
            planning actions, executing tools, and reflecting on results.

            The agent operates in iterative cycles:
            1. **Reasoning**: Analyze the problem and current state
            2. **Planning**: Create action plans based on reasoning
            3. **Acting**: Execute tools and actions according to plans
            4. **Observing**: Process results and outcomes
            5. **Reflecting**: Evaluate progress and adjust strategy

            .. attribute:: config

               ReactAgent configuration

            .. attribute:: thought_history

               History of all thoughts and reasoning steps

            .. attribute:: action_history

               History of all actions taken

            .. attribute:: current_reasoning_step

               Current step in reasoning process

            .. attribute:: tool_call_count

               Number of tool calls made in current session

            .. attribute:: reflection_count

               Number of reflections performed

            .. rubric:: Examples

            Basic ReactAgent usage::

                from testhaive.core.engine.config import TestLLMConfig

                # Configure LLM
                llm_config = TestLLMConfig(
                    name="react_llm",
                    model="gpt-4",
                    temperature=0.7,
                    tools=["web_search", "calculator"]
                )

                # Configure ReactAgent
                react_config = ReactConfig(
                    name="research_assistant",
                    engine=llm_config,
                    max_reasoning_steps=8,
                    enable_reflection=True
                )

                # Create and use agent
                agent = ReactAgent(name="researcher", config=react_config)
                result = agent.run("What are the main risks of artificial intelligence?")

            Advanced usage with async execution::

                async def run_research():
                    agent = ReactAgent(name="async_researcher", config=react_config)
                    result = await agent.arun("Analyze recent developments in AI safety")
                    return result

            Accessing reasoning history::

                agent = ReactAgent(name="tracker", config=react_config)
                result = agent.run("Complex research question")

                # Review reasoning process
                for thought in agent.thought_history:
                    print(f"Thought: {thought.content} (confidence: {thought.confidence})")

                # Review actions taken
                for action in agent.action_history:
                    print(f"Action: {action.description} -> {action.action_type}")

            Initialize ReactAgent with React-specific setup.


            .. py:method:: _can_provide_response() -> bool

               Check if sufficient information is available to provide a response.



            .. py:method:: _execute_actions(actions: List[ActionPlan]) -> List[Dict[str, Any]]

               Execute planned actions.



            .. py:method:: _execute_tool_call(action: ActionPlan) -> Dict[str, Any]

               Execute a tool call action.



            .. py:method:: _generate_final_response() -> str

               Generate final response based on reasoning and observations.



            .. py:method:: _generate_thoughts() -> List[ThoughtProcess]

               Generate thoughts for current reasoning step.



            .. py:method:: _initialize_reasoning_session(input_text: str) -> None

               Initialize a new reasoning session.



            .. py:method:: _perform_reflection() -> None

               Perform reflection on current progress.



            .. py:method:: _plan_actions(thoughts: List[ThoughtProcess]) -> List[ActionPlan]

               Plan actions based on current thoughts.



            .. py:method:: _process_observations(results: List[Dict[str, Any]]) -> List[str]

               Process and analyze action results.



            .. py:method:: _should_reflect() -> bool

               Determine if reflection should be performed.



            .. py:method:: arun(input_text: str) -> str
               :async:


               Async version of the ReactAgent reasoning and action cycle.

               :param input_text: Input query or task description

               :returns: Final response after reasoning and action cycle



            .. py:method:: clear_history() -> None

               Clear reasoning and action history.



            .. py:method:: get_reasoning_summary() -> Dict[str, Any]

               Get a summary of the reasoning process.

               :returns: Dictionary containing reasoning statistics and history



            .. py:method:: run(input_text: str) -> str

               Execute ReactAgent reasoning and action cycle.

               This method implements the complete ReAct cycle:
               1. Initialize reasoning with the input
               2. Generate thoughts and analyze the problem
               3. Plan actions based on reasoning
               4. Execute actions and tools
               5. Observe and process results
               6. Reflect and adjust strategy
               7. Return final response

               :param input_text: Input query or task description

               :returns: Final response after reasoning and action cycle

               .. rubric:: Examples

               Simple query::

                   response = agent.run("What is the capital of France?")

               Complex reasoning task::

                   response = agent.run(
                       "Analyze the pros and cons of renewable energy adoption "
                       "and provide policy recommendations"
                   )



            .. py:attribute:: _reasoning_context
               :type:  Dict[str, Any]
               :value: None



            .. py:attribute:: action_history
               :type:  List[ActionPlan]
               :value: None



            .. py:attribute:: config
               :type:  ReactConfig
               :value: None



            .. py:attribute:: current_reasoning_step
               :type:  int
               :value: None



            .. py:attribute:: reflection_count
               :type:  int
               :value: None



            .. py:attribute:: thought_history
               :type:  List[ThoughtProcess]
               :value: None



            .. py:attribute:: tool_call_count
               :type:  int
               :value: None




      .. grid-item-card:: 
         :class-card: sd-border-0 sd-shadow-sm
         :class-title: sd-text-center sd-font-weight-bold

.. py:class:: SimpleAgent(/, **data: Any)

            Bases: :py:obj:`pydantic.BaseModel`


            Simple agent implementation.

            This agent provides basic functionality for testing documentation structure.
            It mimics the patterns used in haive.agents.simple.SimpleAgent.

            :param name: Agent identifier
            :param config: Agent configuration
            :param state: Current agent state

            .. rubric:: Examples

            Basic usage::

                from testhaive.core.engine.config import TestLLMConfig

                config = TestLLMConfig(name="test", model="gpt-4")
                agent_config = SimpleAgentConfig(name="simple", engine=config)
                agent = SimpleAgent(name="my_agent", config=agent_config)

            With custom configuration::

                config = TestLLMConfig(
                    name="advanced",
                    model="gpt-4",
                    temperature=0.3,
                    tools=["calculator"]
                )
                agent_config = SimpleAgentConfig(
                    name="advanced_agent",
                    engine=config,
                    max_iterations=10,
                    verbose=True
                )
                agent = SimpleAgent(name="advanced", config=agent_config)

            Create a new model by parsing and validating input data from keyword arguments.

            Raises [`ValidationError`][pydantic_core.ValidationError] if the input data cannot be
            validated to form a valid model.

            `self` is explicitly positional-only to allow `self` as a field name.


            .. py:method:: get_stats() -> Dict[str, Any]

               Get agent execution statistics.

               :returns: Dictionary with execution stats



            .. py:method:: reset() -> None

               Reset agent state.



            .. py:method:: run(input_text: str) -> str

               Execute the agent with input text.

               :param input_text: Input text to process

               :returns: Processed output text



            .. py:attribute:: _execution_count
               :type:  int
               :value: None



            .. py:attribute:: config
               :type:  SimpleAgentConfig
               :value: None



            .. py:attribute:: name
               :type:  str
               :value: None



            .. py:attribute:: state
               :type:  Optional[testhaive.core.schema.base.BaseSchema]
               :value: None






----

.. admonition:: Quick Reference
   :class: tip

   .. code-block:: python

      from testhaive.agents import *

      # Module provides type hints for mypy compatibility
      # View source: https://github.com/haive-ai/haive

