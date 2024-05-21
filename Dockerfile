FROM node:20.11.1-bookworm as build

ENV FOUNDRY_DIR /usr/local
RUN curl -L https://foundry.paradigm.xyz | bash && \
  /usr/local/bin/foundryup --version nightly-f625d0fa7c51e65b4bf1e8f7931cd1c6e2e285e9

WORKDIR /

RUN git config --global user.email "hello@settlemint.com" && \
  git config --global user.name "SettleMint" && \
  forge init usecase --template settlemint/solidity-empty && \
  cd usecase && \
  forge build

USER root

FROM busybox

COPY --from=build /usecase /usecase
COPY --from=build /root/.svm /usecase-svm
