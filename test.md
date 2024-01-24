name: Backend Lambda Deploy S3

on:
  push:
    branches:
      - main

jobs:
  example-job:
          runs-on: ubuntu-latest
          steps:
            - name: Configure AWS CLI
              run: |
                mkdir -p ~/.aws/
                echo "$super_secret" > ~/.aws/credentials
              env:
                super_secret: ${{ secrets.AWS_CONFIG1 }}
      
            - name: Show AWS credentials
              run: cat ~/.aws/credentials
      
            - name: List AWS profiles
              run: aws configure list-profiles
      
            - name: List S3 buckets
              run: aws s3 ls --region eu-central-1 --profile techstarter
      
  Lambda-Code-Or-Function:
    runs-on: ubuntu-latest
    outputs:
      LAMBDA_TF: ${{ steps.list-functions.outputs.LAMBDA_TF }}
    steps:
      - name: Lade neuen Repo-Zustand
        uses: actions/checkout@v4  
      - name: List Lambda Functions
        working-directory: ${{ github.workspace }}
        id: list-functions
        run: |
          cd ${{ github.workspace }}
          echo "LAMBDA_TF=$(bash ./.github/scripts/lsdirs.sh)" >> $GITHUB_OUTPUT
          echo "LAMBDI.JSON FILE Created:"
          cat lambdi.json

      - name: Check lambdi.json existence
        run: |
          echo "lambdi.json exists: $(ls -l lambdi.json)"

      - name: result list-functions
        run: echo "${{ steps.list-functions.outputs.LAMBDA_TF }}"
        # trigger Matrix-Job Build-and-Zip-Lambdas
      - name: Deploy Lambdi.json to S3
        run: aws s3 cp lambdi.json s3://tf-backend-abschlussprojekt/lambdi.json
        env:
          super_secret: ${{ secrets.AWS_CONFIG1 }}

        continue-on-error: true
  Build-and-Zip-Lambdas2:
    needs: Lambda-Code-Or-Function
    strategy:
      matrix:
        lambda_function: ${{ fromJson(needs.Lambda-Code-Or-Function.outputs.LAMBDA_TF) }}
        
    runs-on: ubuntu-latest
    steps:
      - name: Lade neuen Repo-Zustand
        uses: actions/checkout@v4  
      - name: Install zip
        uses: montudor/action-zip@v1       
      - name: installiere nodeJs
        uses: actions/setup-node@v3
        with:
          node-version: 18
      - name: Display Funktion - ${{ matrix.lambda_function }}
        run: echo "packing Lambda-Funktion ${{ matrix.lambda_function }}"
      - name: Cache node-modules
        id: cache-node-modules
        uses: actions/cache@v4
        with:
          path: ${{ github.workspace }}/${{ matrix.lambda_function }}
          key: ${{ matrix.lambda_function }}-packages-${{ hashFiles ('${{ matrix.lambda_function }}/package-lock.json') }}
      - name: install node_modules
        if: ${{ steps.cache-node-modules.outputs.cache-hit != 'true' }}
        working-directory: ${{ matrix.lambda_function }}
        continue-on-error: true
        run: |
            npm install
            npm ci
        
      - name: Cache function-zips 
        id: cache-function-zips
        uses: actions/cache@v4
        with:
          path: ${{ github.workspace }}
          key: ${{ matrix.lambda_function }}-zip-${{ hashFiles('${{ matrix.lambda_function }}/index.js', '${{ matrix.lambda_function }}/package-lock.json') }}
      - name: zip functions
        if: steps.cache-function-zips.outputs.cache-hit != 'true'
        run: | 
          zip -q -r ${{ matrix.lambda_function }}.zip ${{ matrix.lambda_function }} node_modules package.json index.js package-lock.json
          echo "packed function ${{ matrix.lambda_function }}"
      - name: Display result
        run: echo "$(ls ${{ matrix.lambda_function }}.zip)"
      - name: deploy lambda-function.zips to s3 and trigger Terraform-Deploy
        run: echo "deploying ${{ matrix.lambda_function }}.zip to s3"