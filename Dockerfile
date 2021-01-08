# The AWS base images provide the following environment variables:
# ・LAMBDA_TASK_ROOT=/var/task
# ・LAMBDA_RUNTIME_DIR=/var/runtime
FROM public.ecr.aws/lambda/python:3.8
COPY container.py requirements.txt ${LAMBDA_TASK_ROOT}/
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip list
CMD [ "container.lambda_handler" ]
