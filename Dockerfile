FROM python:3.6-stretch

ARG DBOT_ARGS
ARG ENVIRONMENT=production

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

RUN mkdir temp

COPY . .

# This is to disable Machine Learning spell search as per README.md
RUN if [ "$ENVIRONMENT" = "development" ] ; then sed -i '/from cogs5e.funcs.lookup_ml import ml_spell_search/d; s/, search_func=ml_spell_search//' cogs5e/lookup.py ; fi

COPY docker/credentials-${ENVIRONMENT}.py credentials.py

ENTRYPOINT python dbot.py $DBOT_ARGS